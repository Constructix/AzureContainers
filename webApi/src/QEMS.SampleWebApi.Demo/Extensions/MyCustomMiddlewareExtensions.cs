// Configure the HTTP request pipeline.
// custom middleware
public static class MyCustomMiddlewareExtensions
{
    public static IApplicationBuilder UseMyCustomMiddleWare(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<MyCustomMiddleware>();
    }
}