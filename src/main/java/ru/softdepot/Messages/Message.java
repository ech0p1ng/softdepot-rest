package ru.softdepot.Messages;

public class Message {
    public enum Entity {
        admin,
        product,
        developer,
        customer,
        cart,
        degreeOfBelonging,
        category,
        dailyStats,
        purchase
    }

    public enum Identifier {
        email,
        id,
        name
    }

    public enum Status {
        alreadyExists,
        notFound
    }

    public static <T> String build(Entity entity, Identifier identifier, T value, Status status) {
        StringBuilder message = new StringBuilder();
        switch (entity) {
            case admin:
                message.append("Администратор");
                break;
            case product:
                message.append("Товар");
                break;
            case developer:
                message.append("Разработчик");
                break;
            case customer:
                message.append("Покупатель");
                break;
            case cart:
                message.append("В корзине товар");
                break;
            case degreeOfBelonging:
                message.append("Степень принадлежности");
                break;
            case category:
                message.append("Категория");
                break;
            case dailyStats:
                message.append("Ежедневная статистика");
                break;
            case purchase:
                message.append("Покупка");
                break;

            default:
                message.append(entity);
                break;
        }

        message.append(" с ");

        switch (identifier) {
            case email:
                message.append("email");
                break;
            case id:
                message.append("id");
                break;
            case name:
                message.append("именем");
                break;
        }
        message.append(" ");
        message.append(value);
        message.append(" ");

        switch (status) {
            case alreadyExists:
                message.append("уже существует");
                break;
            case notFound: {
                message.append("не найден");
                switch (entity) {
                    case degreeOfBelonging:
                    case dailyStats:
                    case category:
                        message.append("а");
                        break;
                }
                break;
            }
        }
        return message.toString();
    }
}
