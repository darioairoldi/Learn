using Microsoft.AspNetCore.Components;

namespace Learn.Web.Client.Pages;

public partial class ContentPage
{
    [Parameter] public string? Path { get; set; }
}
