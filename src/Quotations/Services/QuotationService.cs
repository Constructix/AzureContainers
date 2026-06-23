

using dockerDemo.Quotations.Models;
using Microsoft.Extensions.Logging;

namespace dockerDemo.Quotations.Services
{
    public class QuotationService(IList<Quotation> quotations, ILogger<QuotationService> logger) : IQuotationService
    {
        public async Task<IEnumerable<Quotation>> GetQuotetationsAsync()
        {
            logger.LogInformation("Retrieving Total Quotations: {totalQuotations}", quotations.Count);
            return await Task.FromResult( quotations.AsEnumerable());
        }
        public async Task<bool> AddQuotationAsync(Quotation quotation)
        {
            logger.LogInformation("Adding New Quotation");
            quotations.Add(quotation);
            return await Task.FromResult( true);
        }
    }
    
}
