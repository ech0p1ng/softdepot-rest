package ru.softdepot.Messages;

import java.awt.print.PageFormat;
import java.util.HashMap;
import java.util.Map;

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
        purchase,
        user,
        review
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

    private static final Map<Entity, String> entityStringMap = new HashMap<Entity, String>();

    static {
        entityStringMap.put(Entity.admin ,"Администратор");
        entityStringMap.put(Entity.product ,"Товар");
        entityStringMap.put(Entity.developer ,"Разработчик");
        entityStringMap.put(Entity.customer ,"Покупатель");
        entityStringMap.put(Entity.cart ,"В корзине товар");
        entityStringMap.put(Entity.degreeOfBelonging ,"Степень принадлежности");
        entityStringMap.put(Entity.category ,"Категория");
        entityStringMap.put(Entity.dailyStats ,"Ежедневная статистика");
        entityStringMap.put(Entity.purchase ,"Покупка");
        entityStringMap.put(Entity.user ,"Пользователь");
        entityStringMap.put(Entity.review ,"Отзыв");
    }

    public static <T> String build(Entity entity, Identifier identifier, T value, Status status) {
        StringBuilder message = new StringBuilder();

        message.append(entityStringMap.get(entity));

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
