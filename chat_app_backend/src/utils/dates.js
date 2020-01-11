class Dates {

    static getDateTime() {
        let date = new Date();
        let timezoneDate = new Date(date.valueOf() - date.getTimezoneOffset() * 60000);
        return timezoneDate.toISOString().replace(/\.\d{3}Z$/, '');
    }

}

module.exports = Dates