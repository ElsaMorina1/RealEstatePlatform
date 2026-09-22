using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RealEstatePlatform.Data;
using RealEstatePlatform.Models;
using RealEstatePlatform.Repository;
using RealEstatePlatform.Repository.Interfaces;
using RealEstatePlatform.ViewModels;
namespace RealEstatePlatform.Controllers
{ public class PropertyController : Controller
    { private readonly IPropertyRepository _repository;
        private readonly IWebHostEnvironment _environment;
        private readonly ApplicationDbContext _context; 
        private readonly UserManager<ApplicationUser> _userManager;
        public PropertyController(IPropertyRepository repository,
            IWebHostEnvironment environment, UserManager<ApplicationUser> userManager,
            ApplicationDbContext context) 
        { _repository = repository;
            _environment = environment; 
            _userManager = userManager;
            _context = context; }
        [HttpGet]
        public async Task<IActionResult> Property2(
    string search,
    string category,
    string city,
    decimal? minPrice,
    decimal? maxPrice)
        {
           
            ViewBag.Search = search;
            ViewBag.Category = category;
            ViewBag.City = city;
            ViewBag.MinPrice = minPrice;
            ViewBag.MaxPrice = maxPrice;

            var properties = _context.Properties
                .Include(p => p.Category)
                .AsQueryable();

           
            if (!string.IsNullOrEmpty(search))
            {
                properties = properties.Where(p => p.Title.Contains(search) );
            }

            if (!string.IsNullOrEmpty(category))
            {
                string lowerCategory = category.ToLower();
               
                properties = properties.Where(p => p.Category.Name.ToLower() == lowerCategory);
            }

            if (!string.IsNullOrEmpty(city))
            {
                string lowerCity = city.ToLower();
                
                properties = properties.Where(p => p.City.ToLower() == lowerCity);
            }

            if (minPrice.HasValue)
            {
                properties = properties.Where(p => p.Price >= minPrice);
            }

            if (maxPrice.HasValue)
            {
                properties = properties.Where(p => p.Price <= maxPrice);
            }

            var result = await properties.ToListAsync(); 
            return View(result);
        }

        [HttpPost] 
        public IActionResult Property2() 
        { return View(); }


        public async Task<IActionResult> Index
            (
            string? search,
            int page = 1  )
        { 
            int pageSize = 6;
            var properties = await _repository.GetAllAsync();
            if 
                (!string.IsNullOrEmpty(search))
            {
                properties = properties.Where
                    (x => x.Title.ToLower()
                    .Contains(search.ToLower()));
            }
            var totalItems = properties.Count();
            
            var pagedData = properties .Skip((page - 1) * pageSize) 
                .Take(pageSize); 
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = Math.Ceiling
                ( totalItems / (double)pageSize);
            return View(pagedData);
        }


        public async Task<IActionResult> Details( int id)
        {
            var property = await _context.Properties
                .Include(p => p.Category)
                .FirstOrDefaultAsync(p => p.Id == id);


            if (property == null) return NotFound();
            return View(property); }



        [Authorize(Roles = "Admin")]
        public IActionResult Create() 
        { return View(); }

        [HttpPost]
        [Authorize(Roles = "Admin")] 
        [ValidateAntiForgeryToken] 
        public async Task<IActionResult> Create( PropertyViewModel model) 
        { if (!ModelState.IsValid)
                return View(model); 
            string? fileName = null;
            if (model.ImageFile != null)
            { string uploadFolder = Path.Combine( _environment.WebRootPath, "uploads"); 
                Directory.CreateDirectory( uploadFolder);
                fileName = Guid.NewGuid() + "_" + model.ImageFile.FileName;
                string filePath = Path.Combine( uploadFolder, fileName); 
                using var stream = new FileStream( filePath, FileMode.Create);
                await model.ImageFile .CopyToAsync(stream); } var user = await _userManager .GetUserAsync(User);
            Property property = new Property 
            { Title = model.Title, Description =
            model.Description, Price = model.Price, City = model.City, 
                AddressLine = model.AddressLine, Bedrooms = model.Bedrooms,
                Bathrooms = model.Bathrooms, Area = model.Area, 
                PropertyType = model.PropertyType, Status = model.Status,
                IsFeatured = model.IsFeatured, CategoryId = model.CategoryId,
                ImageUrl = fileName != null ? "/uploads/" + fileName : null,
                UserId = user?.Id
            };
        
            await _repository.AddAsync(property);
            TempData["success"] = "Property created successfully"; 
            return RedirectToAction(nameof(Index)); }
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Edit( int id) 
        { var property = await _repository.GetByIdAsync(id);
            if (property == null) return NotFound(); PropertyViewModel model = new PropertyViewModel
            { Id = property.Id, Title = property.Title, Description = property.Description,
                Price = property.Price, City = property.City, AddressLine = property.AddressLine,
                Bedrooms = property.Bedrooms, Bathrooms = property.Bathrooms, Area = property.Area,
                PropertyType = property.PropertyType, Status = property.Status,
                IsFeatured = property.IsFeatured, CategoryId = property.CategoryId,
                ExistingImage = property.ImageUrl };
            return View(model); }
        [HttpPost] 
        [Authorize(Roles = "Admin")] 
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit( PropertyViewModel model)
        { if (!ModelState.IsValid) return View(model); 
            var property = await _repository .GetByIdAsync(model.Id);
            if (property == null) return NotFound(); if (model.ImageFile != null)
            { string uploadFolder = Path.Combine( _environment.WebRootPath, "uploads");
                string fileName = Guid.NewGuid() + "_" + model.ImageFile.FileName;
                string filePath = Path.Combine( uploadFolder, fileName);
                using var stream = new FileStream( filePath, FileMode.Create);
                await model.ImageFile .CopyToAsync(stream);
                property.ImageUrl = "/uploads/" + fileName;
            }
        
            property.Title = model.Title;
            property.Description = model.Description;
            property.Price = model.Price;
            property.City = model.City;
            property.AddressLine = model.AddressLine;
            property.Bedrooms = model.Bedrooms;
            property.Bathrooms = model.Bathrooms;
            property.Area = model.Area;
            property.PropertyType = model.PropertyType;
            property.Status = model.Status;
            property.IsFeatured = model.IsFeatured;
            property.CategoryId = model.CategoryId;
            await _repository.UpdateAsync(property);
            TempData["success"] = "Property updated successfully";
            return RedirectToAction(nameof(Index)); }
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Delete( int id) 
        { await _repository.DeleteAsync(id);
            return Json( new { success = true }); }
        [HttpGet] 
        
        public async Task<IActionResult> Search( string term)
        { var properties = await _repository.GetAllAsync(); 
            if (!string.IsNullOrEmpty(term))
            { properties = properties.Where
                    (x => x.Title.ToLower()
                    .Contains(term.ToLower())); } 
            return PartialView( "_PropertyCard", properties); }
        [HttpGet]
        public async Task<IActionResult> Filter( string city, decimal? minPrice, decimal? maxPrice)
        { var properties = await _repository.GetAllAsync(); if (!string.IsNullOrWhiteSpace(city))
            { properties = properties.Where(x => x.City.ToLower() .Contains(city.ToLower())); }
            if (minPrice.HasValue) { properties = properties.Where(x => x.Price >= minPrice.Value); }
            if (maxPrice.HasValue) { properties = properties.Where(x => x.Price <= maxPrice.Value); }
            return View( "Index", properties); } 
        public IActionResult Search(PropertyFilterViewModel model)
        { var properties = _context.Properties.AsQueryable();
            if (!string.IsNullOrEmpty(model.Search))
            { properties = properties.Where(x => x.Title.Contains(model.Search)); }
            if (!string.IsNullOrEmpty(model.Category))
            { properties = properties.Where(x => x.Category.Name == model.Category); } 
            if (!string.IsNullOrEmpty(model.City))
            { properties = properties.Where(x => x.City == model.City); }
            if (model.MinPrice.HasValue)
            { properties = properties.Where(x => x.Price >= model.MinPrice); } 
            if (model.MaxPrice.HasValue)
            { properties = properties.Where(x => x.Price <= model.MaxPrice); } 
            model.Properties = properties .Take(10) .ToList();
            return View("SearchResults", model); } 
        [Authorize] 
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult AddComment( int propertyId, string text) 
        { TempData["success"] = "Comment feature ready."; 
            return RedirectToAction( nameof(Details), new { id = propertyId }); }
        [Authorize] 
        public IActionResult AddToFavorites( int id)
        { TempData["success"] = "Added to favorites.";
            return RedirectToAction( nameof(Details), new { id }); }

        public async Task<IActionResult> Favorites()
        {
            var favoriteProperties = await _context.Properties.Include(p => p.Category).ToListAsync();
            return View(favoriteProperties);
        }
        [Authorize]
        public IActionResult AddFavorite(int id)
        { var favorite = new Favorite { PropertyId = id, UserId = _userManager.GetUserId(User) };
            _context.Favorites.Add(favorite);
            _context.SaveChanges();
            return RedirectToAction("Favorites");
        } } }