using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using RealEstatePlatform.Models;

namespace RealEstatePlatform.Data
{
    public class ApplicationDbContext
        : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(
            DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
        private readonly ApplicationDbContext _context;
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Server=DESKTOP-7OL5KLT\\SQLEXPRESS;Database=REP;Trusted_Connection=True;TrustServerCertificate=True");
            }
        }

        public DbSet<Property> Properties { get; set; }

        public DbSet<Category> Categories { get; set; }

        public DbSet<Feature> Features { get; set; }

        public DbSet<PropertyFeature> PropertyFeatures { get; set; }

        public DbSet<FavoriteProperty> FavoriteProperties { get; set; }

        public DbSet<Comment> Comments { get; set; }

        public DbSet<Address> Addresses { get; set; }
        public DbSet<Favorite> Favorites { get; set; }


        protected override void OnModelCreating(
            ModelBuilder builder)
        {
            base.OnModelCreating(builder);

  
            builder.Entity<PropertyFeature>()
                .HasKey(x => new
                {
                    x.PropertyId,
                    x.FeatureId
                });

            builder.Entity<PropertyFeature>()
                .HasOne(x => x.Property)
                .WithMany(x => x.PropertyFeatures)
                .HasForeignKey(x => x.PropertyId);

            builder.Entity<PropertyFeature>()
                .HasOne(x => x.Feature)
                .WithMany(x => x.PropertyFeatures)
                .HasForeignKey(x => x.FeatureId);

     
            builder.Entity<Property>()
                .HasOne(x => x.Category)
                .WithMany(x => x.Properties)
                .HasForeignKey(x => x.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);

           
            builder.Entity<Property>()
                .HasOne(x => x.User)
                .WithMany(x => x.Properties)
                .HasForeignKey(x => x.UserId)
                .OnDelete(DeleteBehavior.Restrict);

       
            builder.Entity<Property>()
                .HasOne(x => x.Address)
                .WithOne(x => x.Property)
                .HasForeignKey<Address>(x => x.PropertyId);

            
            builder.Entity<FavoriteProperty>()
                .HasOne(x => x.User)
                .WithMany()
                .HasForeignKey(x => x.UserId);

            builder.Entity<FavoriteProperty>()
                .HasOne(x => x.Property)
                .WithMany()
                .HasForeignKey(x => x.PropertyId);

    
            builder.Entity<Comment>()
                .HasOne(x => x.User)
                .WithMany()
                .HasForeignKey(x => x.UserId);

            builder.Entity<Comment>()
                .HasOne(x => x.Property)
                .WithMany()
                .HasForeignKey(x => x.PropertyId);

           
            builder.Entity<Property>()
                .Property(x => x.Price)
                .HasPrecision(18, 2);
        }
    }
}
