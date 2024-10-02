package ru.softdepot.core.dao;

interface DAO<T> {
    int add(T obj) throws Exception;
    void update(T obj) throws Exception;
    void delete(int id) throws Exception;
    T getById(int id) throws Exception;
}
