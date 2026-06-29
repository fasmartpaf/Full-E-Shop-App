    final user = ref.watch(currentUserProvider);
    final signedIn = user != null;
    final profile = ref.watch(userProfileProvider).asData?.value;
    final profileName = profile?['name'] as String?;
    final name = (profileName != null && profileName.isNotEmpty)
        ? profileName
        : (user?.displayName?.isNotEmpty ?? false)
            ? user!.displayName!
            : (signedIn ? 'Ara member' : 'Guest');
    final email = (profile?['email'] as String?) ?? user?.email ?? 'Not signed in';