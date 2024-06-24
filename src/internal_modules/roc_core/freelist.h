#ifndef ROC_CORE_FREELIST_H_
#define ROC_CORE_FREELIST_H_

#include <atomic>
#include "roc_core/log.h"
#include "roc_core/panic.h"

namespace roc {
namespace core {

template <typename T>
class Freelist {
public:
    // Node structure for the intrusive list
    struct Node {
        std::atomic<Node*> next;
        Node() : next(nullptr) {}
    };

    //Constructor initializes the head to nullptr
    Freelist() : head_(nullptr) {}
    //Destructor clears the freelisr
    ~Freelist() {
        clear();
    }

    // Push a node to the back of the freelist
    void push_back(T* node) {
        Node* new_node = static_cast<Node*>(node);
        new_node->next = head_.load(std::memory_order_relaxed);
        while (!head_.compare_exchange_weak(new_node->next, new_node, std::memory_order_release, std::memory_order_relaxed)) {}
        roc_log(LogDebug, "Pushed node: %p", node);
    }

    //Pop a node from the back of the freelist
    T* pop_back() {
        Node* old_head = head_.load(std::memory_order_relaxed);
        while (old_head && !head_.compare_exchange_weak(old_head, old_head->next, std::memory_order_acquire, std::memory_order_relaxed)) {}
        if (old_head) {
            roc_log(LogDebug, "Popped node: %p", old_head);
            return static_cast<T*>(old_head);
        }
        return nullptr;
    }

private:
    std::atomic<Node*> head_;  //Head pointer for the freelist

    //Clear the freelist by deleting all nodes
    void clear() {
        while (head_) {
            Node* tmp = head_;
            head_ = head_->next;
            delete tmp;
        }
    }
};

} // namespace core
} // namespace roc

#endif // ROC_CORE_FREELIST_H_
