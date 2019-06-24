### redis 进程模型 - epoll
> redis 实现了四种进程模型(epoll,evport,kqueue,select),本次记录epoll模型的使用

[epoll的使用](https://blog.csdn.net/wallwind/article/details/45439689)

#### epoll
epoll是linux内核下的一个高效处理大批量文件操作符的一个实现,不仅限于socket fd.<br>它会在**超时时间**内唤醒有事件的操作符,其中有两种模式,水平触发和边缘触发。
1. 水平触发是缺省的工作方式，并且同时支持block和no-block socket.内核告诉你一个文件描述符是否就绪，然后就对就绪fd进行IO操作.如果不进行任何操作，内核仍然会继续通知。该模型的错误可能性要小,传统的select/poll 都是模型的代表。
2. 边缘模式有读写时间，只会通知你一次,知道下一次事件再一次触发。比较复杂。

epoll 提供三个接口<br>
epoll_create(int maxfds)来创建一个epoll句柄。<br>
epoll_wait(int epfd, epoll_event *events, int max events, int timeout) 用来查询所有的网络接口,查看哪些可读哪些可写。<br>
epoll_ctl 用来添加/修改/删除 需要侦听的文件描述符及其事件。

### redis epoll 实现