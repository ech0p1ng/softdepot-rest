package ru.softdepot.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import ru.softdepot.core.models.User;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class MyUserDetails implements UserDetails {
    public User user;

    public MyUserDetails(User user) {
        this.user = user;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<String> rolesList = new ArrayList<>();
        for (var role : User.Type.values()) {
            rolesList.add(role.name());
        }
        var rolesArray = rolesList.toArray(new String[0]);

        return Arrays.stream(rolesArray)
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public String getUsername() {
        return user.getName();
    }

    //Учетная запись действительна
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    //Учетная запись не заблокирована
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    //Учетные данные действительны
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    //Пользователь включен
    @Override
    public boolean isEnabled() {
        return true;
    }
}
