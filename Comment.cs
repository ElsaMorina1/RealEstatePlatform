using RealEstatePlatform.Models;

namespace RealEstatePlatform.Models
{
    public class Comment
    {
        public int Id { get; set; }

        public string Text { get; set; }

        public DateTime CreatedAt { get; set; }
            = DateTime.Now;

        public string UserId { get; set; }

        public ApplicationUser User { get; set; }

        public int PropertyId { get; set; }

        public Property Property { get; set; }
    }
}
