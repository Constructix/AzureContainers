using System;
using System.Collections.Generic;
using System.Text;

namespace dockerDemo.Customers.Services.Products
{
    public interface IProductService
    {
        Task<IEnumerable<Product>> GetProductsAsync();
    }
}
