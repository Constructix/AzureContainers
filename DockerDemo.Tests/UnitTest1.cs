namespace DockerDemo.Tests
{
    using dockerDemo.Customers.Services.Products;
    public class ProductServiceTests
    {
        [Fact]
        public void Test1()
        {
            var productService = new ProductService(new List<dockerDemo.Product>(), null);
            Assert.True(productService == null);
        }
    }
}
