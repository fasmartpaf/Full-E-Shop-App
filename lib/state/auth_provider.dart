  Future<void> register(String name, String email, String password) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await UserRepository().createProfile(cred.user!, name: name);
  }