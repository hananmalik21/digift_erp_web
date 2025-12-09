class ModuleDto {
  final int id;
  final String name;
  final String? description;
  final String? status;

  ModuleDto({
    required this.id,
    required this.name,
    this.description,
    this.status,
  });

  factory ModuleDto.fromJson(Map<String, dynamic> json) {
    return ModuleDto(
      id: json['id'] ?? json['module_id'] ?? json['_id'] ?? 0,
      name: json['name']?.toString() ?? 
            json['module_name']?.toString() ?? 
            json['moduleName']?.toString() ?? 
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
