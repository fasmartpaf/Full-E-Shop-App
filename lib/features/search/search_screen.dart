            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: MockCatalog.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = MockCatalog.categories[i];
                  final on = c.id == selected;
                  return Center(
                    child: ChoiceChip(
                      label: Text(c.name),
                      selected: on,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: on ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => ref
                          .read(selectedCategoryProvider.notifier)
                          .state = c.id,
                    ),
                  );
                },
              ),
            ),