using Microsoft.AspNetCore.Mvc;
using QEMS.SampleWebApi.Demo.weatherForecast.Models;

namespace QEMS.SampleWebApi.Demo.WeatherForecast.Controllers;

[ApiController]
[Route("/api/[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries =
    [
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    ];

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecastResponse> Get()
    {
        return Enumerable.Range(1, 5).Select(index => new WeatherForecastResponse
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }
}
