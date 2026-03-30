import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class FilterDropdown extends StatefulWidget {
  final String selected;
  final List<String> data;
  final ValueChanged<String> onChanged;

  const FilterDropdown({
    super.key,
    required this.selected,
    required this.data,
    required this.onChanged,
  });

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showDropdown() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) setState(() => _isOpen = true);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideDropdown,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 4),
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * -6),
                    child: child,
                  ),
                ),
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.06),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.data.mapIndexed((index, year) {
                          final bool isSelected = year == widget.selected;
                          final bool isFirst = index == 0;
                          final bool isLast = index == widget.data.length - 1;

                          return InkWell(
                            onTap: () {
                              widget.onChanged(year);
                              _hideDropdown();
                            },
                            borderRadius: BorderRadius.vertical(
                              top: isFirst ? const Radius.circular(12) : Radius.zero,
                              bottom: isLast ? const Radius.circular(12) : Radius.zero,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? MoColors.mainColor.withValues(alpha: 0.05)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                  top: isFirst ? const Radius.circular(12) : Radius.zero,
                                  bottom: isLast ? const Radius.circular(12) : Radius.zero,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 11,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    year,
                                    style: AppTextStyles.sectionHeader.copyWith(
                                      color: isSelected
                                          ? MoColors.mainColor
                                          : MoColors.carbon,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 20),
                                    const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: MoColors.mainColor,
                                    ),
                                  ] else
                                    const SizedBox(width: 34),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _isOpen ? _hideDropdown : _showDropdown,
        child: Row(
          children: [
            Text(
              widget.selected,
              style: AppTextStyles.sectionHeader.copyWith(
                color: MoColors.carbon,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedRotation(
              turns: _isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 20,
                color: MoColors.carbon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}