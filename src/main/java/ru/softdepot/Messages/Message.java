package ru.softdepot.messages;

public class Message {
    public static <T> String build(Entity entity, Identifier identifier, T value, Status status) {
        StringBuilder message = new StringBuilder(String.format(
                "%s с %s %s %s",
                entity.getName(),
                identifier.getName(),
                value,
                status.getName()
        ));

        switch (entity) {
            case DEGREE_OF_BELONGING:
            case DAILY_STATS:
            case CATEGORY:
                if (status != Status.ALREADY_EXISTS) {
                    message.append("а");
                }
                break;
        }
        return message.toString();
    }

    public enum Entity {
        ADMIN("Администратор"),
        PRODUCT("Товар"),
        DEVELOPER("Разработчик"),
        CUSTOMER("Покупатель"),
        CART("В корзине товар"),
        DEGREE_OF_BELONGING("Степень принадлежности"),
        CATEGORY("Категория"),
        DAILY_STATS("Ежедневная статистика"),
        PURCHASE("Покупка"),
        USER("Пользователь"),
        REVIEW("Отзыв");

        private String name;

        Entity(String name) {
            this.name = name;
        }

        public String getName() {
            return name;
        }
    }

    public enum Identifier {
        EMAIL("email"),
        ID("id"),
        NAME("именем");

        private String name;

        Identifier(String name) {
            this.name = name;
        }

        public String getName() {
            return name;
        }

    }

    public enum Status {
        ALREADY_EXISTS("уже существует"),
        NOT_FOUND("не найден");

        private String name;

        Status(String name) {
            this.name = name;
        }

        public String getName() {
            return name;
        }

    }
}
