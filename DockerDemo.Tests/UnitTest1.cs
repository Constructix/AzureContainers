namespace DockerDemo.Tests
{
    
    using dockerDemo.Customers.Services.Products;
    using Microsoft.Extensions.Logging;
    using Moq;

    public class ProductServiceTests
    {
        [Fact]
        public void Test1()
        {

            var loggerMock = new Mock<ILogger<ProductService>>();

            var productService = new ProductService(new List<dockerDemo.Product>(), loggerMock.Object);
            Assert.True(productService != null);
        }
    }
}
