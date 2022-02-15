class Book < ApplicationRecord
    validates :year, numericality: {only_integer: true}
    validates :book_id, uniqueness: true

    def map_to_detail_json
        return {
                id: self.book_id,
                name: self.name,
                year: self.year,
                author: self.author,
                summary: self.summary,
                publisher: self.publisher,
                pageCount: self.page_count,
                readPage: self.read_page,
                finished: self.finished,
                reading: self.reading,
                insertedAt: self.created_at,
                updatedAt: self.updated_at
        }
    end
end
