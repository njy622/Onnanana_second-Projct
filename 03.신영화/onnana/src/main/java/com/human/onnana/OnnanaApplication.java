package com.human.onnana;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;



@SpringBootApplication
@ComponentScan(basePackages = "com.human.onnana")
public class OnnanaApplication {

	public static void main(String[] args) {
		SpringApplication.run(OnnanaApplication.class, args);
	}

}