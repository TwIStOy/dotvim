/** @noSelfInFile */

declare namespace notify {
  export interface Options {
    title?: string;
    icon?: string;
    /**
     * Time to show notification in milliseconds. Set to `false` to disable
     * timeout.
     */
    timeout?: number | boolean;
    /**
     * Callback for when window opens, received window as argument.
     */
    on_open?: (win: number) => void;
    /**
     * Callback for when window closes, received window as argument.
     */
    on_close?: (win: number) => void;
    /**
     * Function to keep the notification window after timeout.
     */
    keep?: () => boolean;
    /**
     * Function to render a notification buffer.
     */
    render?: string | (() => string);
    /**
     * Notification record or the record `id` field. Replace an existing
     * notification if still open. All arguments not given are inherited from
     * the replaced notification including message and level.
     */
    replace?: number | Record;
    /**
     * Hide this notification from the history.
     */
    hide_from_history?: boolean;
    /**
     * If false, the window will jump to the timed stage. Intended for use
     * in block events.
     */
    animate?: boolean;
  }

  export interface Record {
    id: number;
    /**
     * Lines of the message.
     */
    message: string[];
    /**
     * Log level.
     *
     * @see vim.log.levels
     */
    level: number | string;
    /**
     * Left and right sections of the title.
     */
    title: string[];
    /**
     * Icon used for notification.
     */
    icon: string;
    /**
     * Time of message, as returned by `vim.fn.localtime()`.
     */
    time: number;
    /**
     * Function to render notification buffer.
     */
    render: () => string;
  }
}
