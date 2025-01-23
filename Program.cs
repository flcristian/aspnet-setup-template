using DotNetEnv;
using Microsoft.EntityFrameworkCore;    
using Microsoft.OpenApi.Models;
using AspnetSetupTemplate.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "ASP.NET Setup Template API", Version = "v1" });
});

string envPath = Path.Combine(Directory.GetCurrentDirectory(), ".env");
if (!File.Exists(envPath))
{
    Console.WriteLine($"Configuration Error: .env file not found at {envPath}");
    return;
}

Env.Load();

builder.WebHost.UseKestrel(options =>
{
    options.ListenAnyIP(8080);
});

builder.Logging.ClearProviders();
builder.Logging.AddConsole();

builder.Services.AddCors(options =>
    options.AddPolicy("aspnet-setup-template", domain => domain.WithOrigins("http://localhost:4200")
        .AllowAnyHeader()
        .AllowAnyMethod())
);

var connectionString = $"Server={Env.GetString("DB_HOST")};" +
                      $"Database={Env.GetString("DB_NAME")};" +
                      $"User Id={Env.GetString("DB_USER")};" +
                      $"Password={Env.GetString("DB_PASSWORD")};" +
                      $"Port={Env.GetString("DB_PORT")}";

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "ASP.NET Setup Template API v1");
    c.RoutePrefix = string.Empty; // Set Swagger UI at the app's root
});

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.MapGet("/hello", () => "Hello world!");

app.UseCors("aspnet-setup-template");
app.Run();
