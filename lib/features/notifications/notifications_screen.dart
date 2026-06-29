  Widget _toggle(String title, String sub, bool value, ValueChanged<bool> on) {
    return SwitchListTile(
      value: value,
      onChanged: on,
      activeThumbColor: Colors.white,
      activeTrackColor: AppColors.brand,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(sub,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
    );
  }