using System.ComponentModel.DataAnnotations.Schema;

namespace JwtAuthenticationSample.Models;

public class Product
{
    public int Id { get; set; }
    
    public string Name { get; set; }
    
    public decimal Price { get; set; }

    public int AddressId { get; set; }
    
    [ForeignKey(nameof(AddressId))]
    public Address Address { get; set; }
}