import 'package:flutter/material.dart';
import '../../../../../core/widgets/paginated_dropdown.dart';
import 'package:digify_erp/features/security_console/functions/data/models/module_dto.dart';
import 'package:digify_erp/features/security_console/functions/data/datasources/module_remote_datasource.dart';

class PaginatedModuleDropdown extends StatefulWidget {
  final String? selectedModule;
  final int? selectedModuleId;
  final Function(String?, int?) onChanged;
  final bool isDark;
  final double height;
  final bool showError;

  const PaginatedModuleDropdown({
    super.key,
    this.selectedModule,
    this.selectedModuleId,
    required this.onChanged,
    required this.isDark,
    this.height = 39,
    this.showError = false,
  });

  @override
  State<PaginatedModuleDropdown> createState() =>
      _PaginatedModuleDropdownState();
}

class _PaginatedModuleDropdownState extends State<PaginatedModuleDropdown> {
  ModuleDto? _selectedModuleDto;
  List<ModuleDto> _allModules = [];
  List<ModuleDto> _displayedModules = [];
  bool _isLoading = false;
  bool _hasMore = false;
  String? _error;
  final int _itemsPerPage = 10;
  
  // Local data source instance
  late final ModuleRemoteDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ModuleRemoteDataSourceImpl();
    _loadModules();
    
    // Resolve selected module DTO if we have a selected module name
    if (widget.selectedModule != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resolveSelectedModule();
      });
    }
  }

  @override
  void didUpdateWidget(PaginatedModuleDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedModule != oldWidget.selectedModule) {
      _resolveSelectedModule();
    }
  }

  Future<void> _loadModules({bool append = false}) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final modules = await _dataSource.getModules();
      
      setState(() {
        _allModules = modules;
        
        if (append) {
          // Load more: get next page of items
          final startIndex = _displayedModules.length;
          final endIndex = startIndex + _itemsPerPage;
          final nextPageModules = endIndex <= modules.length
              ? modules.sublist(startIndex, endIndex)
              : modules.sublist(startIndex);
          
          _displayedModules = [..._displayedModules, ...nextPageModules];
          _hasMore = endIndex < modules.length;
        } else {
          // Initial load: get first page
          final firstPageModules = modules.length > _itemsPerPage
              ? modules.sublist(0, _itemsPerPage)
              : modules;
          
          _displayedModules = firstPageModules;
          _hasMore = modules.length > _itemsPerPage;
        }
        
        _isLoading = false;
      });

      // Resolve selected module after loading
      if (widget.selectedModule != null) {
        _resolveSelectedModule();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_hasMore && !_isLoading) {
      await _loadModules(append: true);
    }
  }

  void _resolveSelectedModule() {
    if (_displayedModules.isNotEmpty && widget.selectedModule != null) {
      final module = _displayedModules.firstWhere(
        (m) => m.name == widget.selectedModule,
        orElse: () {
          // If not in displayed modules, check all modules
          if (_allModules.isNotEmpty) {
            final found = _allModules.firstWhere(
              (m) => m.name == widget.selectedModule,
              orElse: () => _displayedModules.first,
            );
            // Add to displayed if not already there
            if (!_displayedModules.contains(found)) {
              _displayedModules.insert(0, found);
            }
            return found;
          }
          return _displayedModules.first;
        },
      );
      setState(() {
        _selectedModuleDto = module;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.showError
                  ? const Color(0xFFFB2C36)
                  : const Color(0xFFD1D5DC),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PaginatedDropdown<ModuleDto>(
            items: _displayedModules,
            selectedValue: _selectedModuleDto,
            getLabel: (module) => module.name,
            onChanged: (module) {
              setState(() {
                _selectedModuleDto = module;
              });
              widget.onChanged(module?.name, module?.id);
            },
            onLoadMore: _loadMore,
            isLoading: _isLoading,
            hasMore: _hasMore,
            hintText: 'Select module',
            isDark: widget.isDark,
            height: widget.height,
            error: _error,
          ),
        ),
        if (widget.showError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }
}
