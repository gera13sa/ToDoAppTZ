import SwiftUI

struct TaskDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var presenter: TaskDetailsPresenter
    @FocusState private var focusedField: Field?
    @State private var isDatePickerPresented = false

    private enum Field {
        case title
        case description
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Название", text: $presenter.title, axis: .vertical)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .focused($focusedField, equals: .title)

                    Button {
                        focusedField = nil
                        isDatePickerPresented = true
                    } label: {
                        Text(presenter.date.formattedTaskDate)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .buttonStyle(.plain)

                    TextField("Описание", text: $presenter.description, axis: .vertical)
                        .font(.body)
                        .foregroundStyle(.white)
                        .lineLimit(5...)
                        .focused($focusedField, equals: .description)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presenter.save()
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .foregroundStyle(AppTheme.accent)
                }
            }
        }
        .onDisappear {
            presenter.save()
        }
        .sheet(isPresented: $isDatePickerPresented) {
            NavigationStack {
                DatePicker(
                    "Дата",
                    selection: $presenter.date,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(AppTheme.accent)
                .padding()
                .navigationTitle("Дата")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Готово") {
                            isDatePickerPresented = false
                        }
                        .foregroundStyle(AppTheme.accent)
                    }
                }
            }
            .presentationDetents([.medium])
            .preferredColorScheme(.dark)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        TaskDetailsModule.build(
            taskId: TaskItem.previewItems[3].id,
            repository: InMemoryTaskRepository()
        )
    }
}
