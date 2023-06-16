using JwtAuthenticationSample.Models;

namespace JwtAuthenticationSample.Services;

public interface IJwtTokenService
{
    string CreateToken(User user);
}