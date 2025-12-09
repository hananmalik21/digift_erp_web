class OperationDto {
  final int id;
  final String name;
  final String? description;
  final String? status;

  OperationDto({
    required this.id,
    required this.name,
    this.description,
    this.status,
  });

  factory OperationDto.fromJson(Map<String, dynamic> json) {
    return OperationDto(
      id: json['id'] ?? json['operation_id'] ?? json['_id'] ?? 0,
      name: json['name']?.toString() ?? 
            json['operation_name']?.toString() ?? 
            json['operationName']?.toString() ?? 
            '',
      description: json['description']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    };
  }
}
