import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tdd_tutorial/core/common/views/loading_view.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';
import 'package:tdd_tutorial/src/authentication/presentation/widgets/add_user_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUsers() async {
    await context.read<AuthCubit>().getUsers();
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        } else if (state is UserCreatedState) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => const AddUserDialog(),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add usuario"),
            ),
            body: LoadingView(
              state: state,
              child: state is UsersLoadedState
                  ? ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final date = DateTime.parse(user.createdAt);
                        return ListTile(
                          leading: Image.network(user.avatar!),
                          title: Text(user.name),
                          subtitle:
                              Text(DateFormat.yMMMMd("pt_BR").format(date)),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ));
      },
    );
  }
}
