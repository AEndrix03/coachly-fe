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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: completed
              ? [const Color(0xFF10B981).withOpacity(0.2), const Color(0xFF059669).withOpacity(0.15)]
              : [const Color(0xFF0F0F14), const Color(0xFF0A0A0F)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed ? const Color(0xFF10B981) : const Color(0xFF2A2A3A),
          width: completed ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          _buildTypeDropdown(),
          const SizedBox(width: 8),
          _buildWeightInput(),
          const SizedBox(width: 4),
          const Text('×', style: TextStyle(color: Colors.white38, fontSize: 14)),
          const SizedBox(width: 4),
          _buildRepsInput(),
          const SizedBox(width: 6),
          _buildMenu(context),
          _buildCheckbox(),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: type,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF1E1E2A),
        isDense: true,
        icon: const SizedBox.shrink(),
        menuMaxHeight: 300,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        items: typeMap.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.key, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return typeMap.entries.map((entry) {
            return Center(
              child: Text(
                entry.value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
      width: 68,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: weight.toStringAsFixed(weight.truncateToDouble() == weight ? 0 : 1)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
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
          const SizedBox(width: 2),
          const Text(
            'kg',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepsInput() {
    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: TextEditingController(text: reps.toString()),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          final parsed = int.tryParse(value);
          if (parsed != null) onRepsChanged(parsed);
        },
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      icon: const Icon(Icons.more_vert, color: Colors.white38, size: 18),
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final position = button.localToGlobal(Offset.zero, ancestor: overlay);
        
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy + button.size.height,
            overlay.size.width - position.dx - button.size.width,
            0,
          ),
          color: const Color(0xFF2A2A3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          items: [
            const PopupMenuItem(
              value: 'notes',
              child: Text('Note serie', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Text('Duplica', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Elimina', style: TextStyle(color: Colors.red, fontSize: 14)),
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
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(
      value: completed,
      onChanged: (value) {
        if (value != null) onCompleteToggle(value);
      },
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF10B981);
        }
        return const Color(0xFF2A2A3A);
      }),
      checkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}
