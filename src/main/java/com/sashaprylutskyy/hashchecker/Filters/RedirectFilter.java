package com.sashaprylutskyy.hashchecker.Filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;

@WebFilter(urlPatterns = "/*", dispatcherTypes = {DispatcherType.REQUEST})
public class RedirectFilter implements Filter {

    private static final Map<String, String> URL_MAPPINGS = new HashMap<>();
    private static final String JSP_PATH = "/JSP/";

    static {
        URL_MAPPINGS.put("/", "index.jsp");
        URL_MAPPINGS.put("/login", "login.jsp");
        URL_MAPPINGS.put("/registration", "registration.jsp");
        URL_MAPPINGS.put("/upload", "upload.jsp");
//        URL_MAPPINGS.put("/welcome", "welcome.jsp");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();

        if (uri.equals("/logout")) {
            filterChain.doFilter(request, response);
        } else if (isStaticResource(uri) || "POST".equalsIgnoreCase(httpRequest.getMethod())) {
            filterChain.doFilter(request, response);
        } else {
            String jspPage = URL_MAPPINGS.getOrDefault(uri, "404.jsp");
            httpRequest.getRequestDispatcher(JSP_PATH + jspPage).forward(request, response);
        }
    }

    private boolean isStaticResource(String uri) {
        return uri.startsWith("/CSS") || uri.startsWith("/JS") || uri.startsWith("/libs") || uri.startsWith("/img");
    }
}