import SwiftUI

struct MainListView: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var presenter: MainListPresenter
    let repository: TaskRepositoryProtocol

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .bottom) {
                AppTheme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    searchBar
                    content
                }

                if !presenter.isLoading && presenter.errorMessage == nil {
                    BottomTaskBar(countText: presenter.countText) {
                        presenter.didTapCreate()
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: TaskNavigation.self) { route in
                switch route {
                case .detail(let id):
                    TaskDetailsModule.build(taskId: id, repository: repository)
                case .create:
                    TaskDetailsModule.buildNew(repository: repository)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            presenter.onAppear()
        }
        .onChange(of: navigationPath.count) { oldValue, newValue in
            if newValue < oldValue {
                presenter.onAppear()
            }
        }
    }

    private var header: some View {
        Text("Задачи")
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)
    }

    private var searchBar: some View {
        TaskSearchBar(text: $presenter.searchQuery)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
    }

    @ViewBuilder
    private var content: some View {
        if presenter.isLoading {
            Spacer()
            ProgressView()
                .tint(AppTheme.accent)
            Spacer()
        } else if let error = presenter.errorMessage {
            Spacer()
            ContentUnavailableView {
                Label("Ошибка загрузки", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Повторить") {
                    presenter.onAppear()
                }
                .foregroundStyle(AppTheme.accent)
            }
            Spacer()
        } else if presenter.filteredItems.isEmpty {
            Spacer()
            ContentUnavailableView(
                presenter.searchQuery.isEmpty ? "Нет задач" : "Ничего не найдено",
                systemImage: "checklist"
            )
            Spacer()
        } else {
            List {
                ForEach(presenter.filteredItems) { task in
                    TaskRowView(
                        task: task,
                        onToggle: { presenter.didToggleCompletion(for: task) },
                        onOpen: { presenter.didSelect(task) }
                    )
                    .listRowBackground(AppTheme.background)
                    .listRowSeparatorTint(AppTheme.separator)
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .contextMenu {
                        TaskPreviewCard(task: task)
                            .padding(.bottom, 4)

                        Button {
                            presenter.didSelect(task)
                        } label: {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }

                        ShareLink(item: task.shareText) {
                            Label("Поделиться", systemImage: "square.and.arrow.up")
                        }

                        Button(role: .destructive) {
                            presenter.didDelete(task)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .contentMargins(.bottom, 80, for: .scrollContent)
        }
    }
}

#Preview {
    MainListModule.build(
        navigationPath: .constant(NavigationPath()),
        repository: InMemoryTaskRepository()
    )
}
