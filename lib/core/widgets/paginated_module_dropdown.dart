import 'package:flutter/material.dart';
import '../widgets/paginated_dropdown.dart';
import 'package:digify_erp/features/security_console/functions/data/models/module_dto.dart';
import 'package:digify_erp/features/security_console/functions/data/datasources/module_remote_datasource.dart';

/// Reusable paginated module dropdown widget for use across the app
class PaginatedModuleDropdown extends StatefulWidget {
  final String? selectedModule;
  final int? selectedModuleId;
  final Function(String?, int?) onChanged;
  final bool isDark;
  final double height;
  final bool showError;
  final String hintText;

  const PaginatedModuleDropdown({
    super.key,
    this.selectedModule,
    this.selectedModuleId,
    required this.onChanged,
    required this.isDark,
    this.height = 39,
    this.showError = false,
    this.hintText = 'Select module',
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

      // Resolve selected module after loading and notify parent
      if (widget.selectedModule != null && widget.selectedModule != 'All Modules' && widget.selectedModuleId == null) {
        _resolveSelectedModule();
        // Notify parent once data is loaded - defer to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final moduleList = _displayedModules.isNotEmpty ? _displayedModules : _allModules;
          if (moduleList.isNotEmpty) {
            try {
              final module = moduleList.firstWhere(
                (m) => m.name == widget.selectedModule,
              );
              widget.onChanged(module.name, module.id);
            } catch (e) {
              // Try case-insensitive match
              try {
                final module = moduleList.firstWhere(
                  (m) => m.name.toLowerCase() == widget.selectedModule!.toLowerCase(),
                );
                widget.onChanged(module.name, module.id);
              } catch (e2) {
                // Fallback to first item
                if (moduleList.isNotEmpty) {
                  widget.onChanged(moduleList.first.name, moduleList.first.id);
                }
              }
            }
          }
        });
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
    if (widget.selectedModule != null && widget.selectedModule != 'All Modules') {
      if (_displayedModules.isNotEmpty || _allModules.isNotEmpty) {
        final moduleList = _displayedModules.isNotEmpty ? _displayedModules : _allModules;
        final module = moduleList.firstWhere(
          (m) => m.name == widget.selectedModule,
          orElse: () {
            // If not in displayed modules, check all modules
            if (_allModules.isNotEmpty && _displayedModules.isNotEmpty) {
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
            return moduleList.isNotEmpty ? moduleList.first : _allModules.first;
          },
        );
        setState(() {
          _selectedModuleDto = module;
        });
        // Always notify parent if ID wasn't provided (ensures ID is set in edit mode)
        if (widget.selectedModuleId == null) {
          // Defer to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged(module.name, module.id);
          });
        }
      }
    } else {
      // "All Modules" selected or null
      setState(() {
        _selectedModuleDto = null;
      });
    }
  }

  Widget _buildModuleDropdown() {
    // Check if hintText is "All Modules" to support the "All Modules" option
    final supportsAllOption = widget.hintText == 'All Modules';
    
    if (supportsAllOption) {
      // Create a wrapper that includes "All Modules" as first item
      final allModulesItem = const _AllModulesItem();
      final allItems = <dynamic>[allModulesItem, ..._displayedModules];
      
      // Determine selected value - null or "All Modules" means allModulesItem is selected
      dynamic selectedValue = _selectedModuleDto;
      if (widget.selectedModule == null || widget.selectedModule == 'All Modules') {
        selectedValue = allModulesItem;
      }
      
      return PaginatedDropdown<dynamic>(
        items: allItems,
        selectedValue: selectedValue,
        getLabel: (item) => item is _AllModulesItem ? 'All Modules' : (item as ModuleDto).name,
        onChanged: (item) {
          if (item is _AllModulesItem) {
            setState(() {
              _selectedModuleDto = null;
            });
            // Defer to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onChanged(null, null);
            });
          } else if (item is ModuleDto) {
            setState(() {
              _selectedModuleDto = item;
            });
            // Defer to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onChanged(item.name, item.id);
            });
          }
        },
        onLoadMore: _loadMore,
        isLoading: _isLoading,
        hasMore: _hasMore,
        hintText: widget.hintText,
        isDark: widget.isDark,
        height: widget.height,
        error: _error,
        enableSearch: true,
        useApiSearch: false, // Local search for modules
      );
    } else {
      // Standard dropdown without "All Modules" option
      return PaginatedDropdown<ModuleDto>(
        items: _displayedModules,
        selectedValue: _selectedModuleDto,
        getLabel: (module) => module.name,
        onChanged: (module) {
          setState(() {
            _selectedModuleDto = module;
          });
          // Defer to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged(module?.name, module?.id);
          });
        },
        onLoadMore: _loadMore,
        isLoading: _isLoading,
        hasMore: _hasMore,
        hintText: widget.hintText,
        isDark: widget.isDark,
        height: widget.height,
        error: _error,
        enableSearch: true,
        useApiSearch: false, // Local search for modules
      );
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
          child: _buildModuleDropdown(),
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

// Helper class to represent "All Modules" option
class _AllModulesItem {
  const _AllModulesItem();
}
