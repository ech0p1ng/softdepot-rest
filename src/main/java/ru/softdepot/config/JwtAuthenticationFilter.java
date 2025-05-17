package ru.softdepot.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.core.dao.UserDAO;

import java.io.IOException;

@Configuration

public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final UserDAO userDAO;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider,
                                   UserDAO customUserDetailsService) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.userDAO = customUserDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException, ResponseStatusException {
        // Получение JWT токена из cookie
        String jwtToken = null;
        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if ("JWT-TOKEN".equals(cookie.getName())) {
                    jwtToken = cookie.getValue();
                }
            }
        }

        if (jwtToken != null && jwtTokenProvider.validateToken(jwtToken)) {
            String username = jwtTokenProvider.getUsername(jwtToken);
            var userDetails = userDAO.loadUserByUsername(username);
            if (userDetails == null) {
                throw new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Неверное имя пользователя или пароль"
                );
            }
            UsernamePasswordAuthenticationToken auth =
                    new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
            auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        filterChain.doFilter(request, response);
    }
}
