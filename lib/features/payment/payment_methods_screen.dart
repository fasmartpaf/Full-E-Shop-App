      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card_off_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No saved cards', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Add a card for faster checkout.'),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _openForm(context),
                      style: FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                      child: const Text('Add card'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(