using MailKit.Net.Smtp;
using MimeKit;

namespace RealEstatePlatform.Services
{
    public class EmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(
            IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendEmail(
            string name,
            string email,
            string message)
        {
            var mimeMessage =
                new MimeMessage();

            mimeMessage.From.Add(
                new MailboxAddress(
                    name,
                    email));

            mimeMessage.To.Add(
                new MailboxAddress(
                    "Admin",
                    _configuration["EmailSettings:SenderEmail"]));

            mimeMessage.Subject =
                "New Contact Message";

            mimeMessage.Body =
                new TextPart("plain")
                {
                    Text =
                        $"Name: {name}\n" +
                        $"Email: {email}\n\n" +
                        $"{message}"
                };

            using var smtp =
                new SmtpClient();

            await smtp.ConnectAsync(
                _configuration["EmailSettings:SmtpServer"],
                Convert.ToInt32(
                    _configuration["EmailSettings:Port"]),
                false);

            await smtp.AuthenticateAsync(
                _configuration["EmailSettings:SenderEmail"],
                _configuration["EmailSettings:Password"]);

            await smtp.SendAsync(
                mimeMessage);

            await smtp.DisconnectAsync(
                true);
        }
    }
}