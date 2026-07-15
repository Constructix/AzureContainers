using Microsoft.AspNetCore.Mvc;
using QEMS.SampleWebApi.Demo.Responses;

namespace QEMS.SampleWebApi.Demo.Controllers;

[ApiController]
[Route("/api/[controller]")]
public class ProductController : ControllerBase
{
   
    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<ProductResponse> Get()
    {
        return Enumerable.Range(1, 5).Select(index => new ProductResponse
        {
            Name = "AAAA",
            Quantity = new Random().Next(1, 60),
            Created = DateTime.Now.AddDays(new Random((int)DateTime.Now.Ticks).Next(1, 67)),
            UnitPrice = 463.34m
        }).ToArray();
    }
}
