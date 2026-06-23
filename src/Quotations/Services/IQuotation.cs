

using dockerDemo.Quotations.Models;

namespace dockerDemo.Quotations.Services
{
    public interface IQuotationService
    {
        Task <IEnumerable<Quotation>> GetQuotetationsAsync ();
        Task <bool> AddQuotationAsync(Quotation quoation);
    }
    
}
