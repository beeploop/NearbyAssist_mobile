import 'package:flutter/material.dart';

class ListenableLoadingButton extends StatefulWidget {
  const ListenableLoadingButton({
    super.key,
    required this.listenable,
    required this.onPressed,
    required this.isLoadingFunction,
  });

  final Listenable listenable;
  final void Function() onPressed;
  final bool Function() isLoadingFunction;

  @override
  State<ListenableLoadingButton> createState() => _ListenableLoadingButton();
}

class _ListenableLoadingButton extends State<ListenableLoadingButton> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.listenable,
        builder: (context, _) {
          final isLoading = widget.isLoadingFunction();

          return FloatingActionButton.extended(
            elevation: 0,
            onPressed: () => widget.onPressed(),
            label: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
            backgroundColor: isLoading
                ? Theme.of(context).disabledColor
                : Theme.of(context).primaryColor,
          );
        });
  }
}
