package ru.softdepot.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class HtmlPagesController {
    @GetMapping
    public String mainPage() {
        return "mainpage/index.html";
    }

    @GetMapping("/programs/{programId}")
    public String programPage(@PathVariable String programId, Model model) {
        return "program/index.html";
    }

//    @GetMapping("/new")
//    public String newPage() {
//
//    }
}
