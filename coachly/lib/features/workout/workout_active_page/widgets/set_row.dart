import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetRow extends StatelessWidget {
  final String type;
  final double weight;
  final int reps;
  final bool completed;
  final ValueChanged<bool> onCompleteToggle;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const SetRow({
    super.key,
    required this.type,
    required this.weight,
    required this.reps,
    required this.completed,
    required this.onCompleteToggle,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onTypeChanged,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        gradient: completed
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1F2937), Color(0xFF111827)],
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed ? const Color(0xFF34D399) : const Color(0xFF374151),
          width: completed ? 2 : 1.5,
        ),
        boxShadow: completed
            ? [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          _buildTypeDropdown(),
          const SizedBox(width: 10),
          Flexible(flex: 3, child: _buildWeightInput()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.close,
              color: completed
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white.withOpacity(0.4),
              size: 14,
            ),
          ),
          Flexible(flex: 2, child: _buildRepsInput()),
          const SizedBox(width: 6),
          _buildMenu(context),
          const SizedBox(width: 8),
          _buildModernCheckbox(),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    final typeMap = {
      'Normale': 'N',
      'Riscaldamento': 'R',
      'Cedimento': 'C',
      'Dropset': 'D',
      'Buffer': 'B',
      'Volume': 'V',
      'Avvicinamento': 'A',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: completed
            ? Colors.white.withOpacity(0.15)
            : const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed
              ? Colors.white.withOpacity(0.3)
              : const Color(0xFF374151),
          width: 1.5,
        ),
      ),
      child: DropdownButton<String>(
        value: type,
        underline: const SizedBox.shrink(),
        dropdownColor: const Color(0xFF1F2937),
        isDense: true,
        icon: const SizedBox.shrink(),
        menuMaxHeight: 320,
        borderRadius: BorderRadius.circular(12),
        style: TextStyle(
          color: completed ? Colors.white : Colors.white70,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        items: typeMap.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: SizedBox(
              width: 160, // ✅ LARGHEZZA FISSA per menu leggibile
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    // Badge con lettera
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF374151), Color(0xFF1F2937)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF4B5563),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nome completo
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return typeMap.entries.map((entry) {
            return Center(
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: completed ? Colors.white : Colors.white70,
                ),
              ),
            );
          }).toList();
        },
        onChanged: (value) {
          if (value != null) onTypeChanged(value);
        },
      ),
    );
  }

  Widget _buildWeightInput() {
    return Container(
      constraints: const BoxConstraints(minWidth: 75, maxWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: completed
            ? Colors.white.withOpacity(0.15)
            : const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed
              ? Colors.white.withOpacity(0.3)
              : const Color(0xFF374151),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(
                text: weight.toStringAsFixed(
                  weight.truncateToDouble() == weight ? 0 : 1,
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: completed ? Colors.white : Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
              ],
              onChanged: (value) {
                final parsed = double.tryParse(value);
                if (parsed != null) onWeightChanged(parsed);
              },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'kg',
            style: TextStyle(
              color: completed
                  ? Colors.white.withOpacity(0.7)
                  : Colors.white.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepsInput() {
    return Container(
      constraints: const BoxConstraints(minWidth: 55, maxWidth: 70),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: completed
            ? Colors.white.withOpacity(0.15)
            : const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed
              ? Colors.white.withOpacity(0.3)
              : const Color(0xFF374151),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: TextEditingController(text: reps.toString()),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: completed ? Colors.white : Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        onChanged: (value) {
          final parsed = int.tryParse(value);
          if (parsed != null) onRepsChanged(parsed);
        },
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          Icons.more_vert,
          color: completed
              ? Colors.white.withOpacity(0.8)
              : Colors.white.withOpacity(0.4),
          size: 20,
        ),
        onPressed: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          final position = button.localToGlobal(Offset.zero, ancestor: overlay);

          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              position.dx,
              position.dy + button.size.height,
              overlay.size.width - position.dx - button.size.width,
              0,
            ),
            color: const Color(0xFF1F2937),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF374151), width: 1),
            ),
            items: <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'notes',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Note serie',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'duplicate',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.content_copy_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Duplica',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Elimina',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).then((value) {
            switch (value) {
              case 'notes':
                // TODO: Note serie
                break;
              case 'duplicate':
                onDuplicate();
                break;
              case 'delete':
                onDelete();
                break;
            }
          });
        },
      ),
    );
  }

  Widget _buildModernCheckbox() {
    return GestureDetector(
      onTap: () => onCompleteToggle(!completed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          gradient: completed
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF059669), // Emerald 600 SCURO
                    Color(0xFF047857), // Emerald 700 PIÙ SCURO
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF374151), const Color(0xFF1F2937)],
                ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: completed
                ? const Color(0xFF34D399)
                : const Color(0xFF4B5563),
            width: 2,
          ),
          boxShadow: completed
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: completed
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
            : null,
      ),
    );
  }
}
