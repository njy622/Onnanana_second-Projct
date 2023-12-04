package com.human.onnana.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ButtonController {

    @PostMapping("/buttonAction")
    public String handleButtonClick(@RequestParam("buttonIndex") String buttonIndex) {
        // 버튼이 눌렸을 때의 동작 처리
        System.out.println("Button " + buttonIndex + " Clicked!");

        // 예시: 다시 index 페이지로 리다이렉트
        return "redirect:/weather";
    }
}