using Microsoft.Extensions.Logging;

namespace dockerDemo.Customers.Services.Products
{
    public class ProductService(List<Product> products, ILogger<ProductService> logger) : IProductService
    {      

        public Task<IEnumerable<Product>> GetProductsAsync()
        {
            
            logger.LogInformation(@"Retrieveing products from product service. Total products: {products}", products.Count);
            return Task.FromResult<IEnumerable<Product>>(products);
        }
    }
}
