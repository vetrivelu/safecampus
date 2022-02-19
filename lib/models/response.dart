class Response {
  Response({
    required this.code,
    required this.message,
  });

  String code;
  String message;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };

  factory Response.error(error) => Response(code: "Error", message: error);
  factory Response.success(message) => Response(code: "Success", message: message);
}
