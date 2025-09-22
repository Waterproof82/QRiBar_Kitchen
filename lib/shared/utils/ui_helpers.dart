import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/onboarding/domain/usecases/first_time_usecase.dart';

Future<bool> onBackPressed(BuildContext context) async {
  final listenerBloc = context.read<ListenerBloc>();
  final l10n = AppLocalizations.of(context);

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      alignment: Alignment.center,
      title: Text(l10n.exitMenu, textAlign: TextAlign.center),
      content: Text(l10n.closeApp, textAlign: TextAlign.center),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 1,
              color: Colors.black26,
              onPressed: () async {
                await listenerBloc.close();
                context.read<FirstTimeUseCase>().resetFirstTime();
                SystemNavigator.pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                child: Text(
                  l10n.yes,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 0, 0),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 1,
              color: Colors.black26,
              onPressed: () {
                context.pop(false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                child: Text(
                  l10n.no,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return result ?? false;
}

Future<void> salirApp({bool? animated}) async {
  await SystemChannels.platform.invokeMethod<void>(
    'SystemNavigator.pop',
    animated,
  );
}
