package com.example.realestate.config;

import com.example.realestate.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.http.HttpMethod;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final AuthenticationProvider authenticationProvider;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthFilter, AuthenticationProvider authenticationProvider) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.authenticationProvider = authenticationProvider;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/auth/**").permitAll()
                        
                        // Milestones: Only PROJECT OWNER can create and update. INVESTOR can read.
                        .requestMatchers(HttpMethod.POST, "/api/milestones/add").hasAnyRole("ADMIN", "LANDOWNER", "INVESTOR")
                        .requestMatchers(HttpMethod.PUT, "/api/milestones/*/status").hasAnyRole("ADMIN", "LANDOWNER", "INVESTOR")
                        .requestMatchers(HttpMethod.GET, "/api/projects/*/milestones/**").hasAnyRole("INVESTOR", "LANDOWNER", "ADMIN")
                        
                        // Projects
                        .requestMatchers(HttpMethod.GET, "/api/projects/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/projects/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/projects/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/projects/**").hasRole("ADMIN")
                        
                        // Lands
                        .requestMatchers(HttpMethod.GET, "/api/lands/**").hasAnyRole("ADMIN", "LANDOWNER", "INVESTOR")
                        .requestMatchers(HttpMethod.POST, "/api/lands/**").hasAnyRole("LANDOWNER", "INVESTOR")
                        .requestMatchers(HttpMethod.PUT, "/api/lands/*/review").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/lands/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/lands/**").hasRole("ADMIN")
                        
                        // EOIs
                        .requestMatchers(HttpMethod.POST, "/api/eois/**").hasRole("INVESTOR")
                        .requestMatchers(HttpMethod.GET, "/api/eois/investor/**").hasRole("INVESTOR")
                        .requestMatchers(HttpMethod.GET, "/api/eois/project/**").hasAnyRole("ADMIN", "LANDOWNER", "INVESTOR")
                        .requestMatchers(HttpMethod.GET, "/api/eois/**").hasRole("ADMIN")

                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
