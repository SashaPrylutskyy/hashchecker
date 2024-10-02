package com.sashaprylutskyy.hashchecker;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class RedirectServlet implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();

        if (uri.startsWith("/CSS") || uri.startsWith("/JS") || uri.startsWith("/img")) {
            filterChain.doFilter(request, response); // Пропустити запит для статичних файлів
            return;
        }

        switch (uri) {
            case "/":
                httpRequest.getRequestDispatcher("/JSP/index.jsp").forward(request, response);
                break;
            case "/login":
                httpRequest.getRequestDispatcher("/JSP/login.jsp").forward(request, response);
                break;
            case "/registration":
                httpRequest.getRequestDispatcher("/JSP/registration.jsp").forward(request, response);
            case "/upload":
                httpRequest.getRequestDispatcher("/JSP/upload.jsp").forward(request, response);
            case "/welcome":
                httpRequest.getRequestDispatcher("/JSP/welcome.jsp").forward(request, response);
        }

        httpRequest.getRequestDispatcher("JSP/404.jsp").forward(request, response);
    }
}
