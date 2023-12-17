import 'package:flutter/material.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';

class LoadingView extends StatelessWidget {
  final AuthState state;
  final Widget child;
  const LoadingView({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        state is GettingUsersState
            ? const _LoadingIndicator(
                text: "Coletando usuarios",
              )
            : state is CreatingUserState
                ? const _LoadingIndicator(
                    text: "Criando usuario",
                  )
                : const SizedBox.shrink(),
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final String text;
  const _LoadingIndicator({required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white38,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
