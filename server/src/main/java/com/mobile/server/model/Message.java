package com.mobile.server.model;

import lombok.*;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Message {
    String message;
    String from;
}

