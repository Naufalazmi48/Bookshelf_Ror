require 'json'

class BooksController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
            books = Book.all
            name = params[:name]
            reading = params[:reading]
            finished = params[:finished]

            if !name.nil?
                books = books.filter {|book| book.name.downcase.include? name.downcase }
            elsif !reading.nil?
                books = books.filter {|book| book.reading == (reading == '1')}
            elsif !finished.nil?
                books = books.filter {|book| book.finished == (finished == '1')}
            end

            response = {:status => 'success', :data => {:books => books.map { |book| {id: book.book_id, name: book.name, publisher: book.publisher}}}}
            render json: response, status: :ok
    end

    def create
        name = params[:name]
        year = params[:year]
        author = params[:author]
        summary = params[:summary]
        publisher = params[:publisher]
        pageCount = params[:pageCount]
        readPage = params[:readPage]
        reading = params[:reading]

        id = generateRandomId()
        finished = pageCount == readPage

        if name.nil?
            response = {:status => 'fail', :message => 'Gagal menambahkan buku. Mohon isi nama buku'}
            render json: response, status: :bad_request and return
        end

        if readPage > pageCount
            response = {:status => 'fail', :message => 'Gagal menambahkan buku. readPage tidak boleh lebih besar dari pageCount'}
            render :json => response, status: :bad_request and return
        end

        book = Book.new(book_id: id, name: name, year: year, author: author, summary: summary, publisher: publisher, page_count: pageCount, read_page: readPage, finished: finished, reading: reading)

        if book.valid?
            book.save
            response = { :status => 'success', :message => 'Buku berhasil ditambahkan', :data => {:bookId => id}}
            render json: response, status: :created and return
        else
            response = { :status => 'error', :message => 'Buku gagal ditambahkan'}
            render json: response, status:  :internal_server_error and return
        end
    end

    def update
        id = params[:id]
        name = params[:name]
        year = params[:year]
        author = params[:author]
        summary = params[:summary]
        publisher = params[:publisher]
        pageCount = params[:pageCount]
        readPage = params[:readPage]
        reading = params[:reading]

        if name.nil?
            response = {:status => 'fail', :message => 'Gagal memperbarui buku. Mohon isi nama buku'}
            render json: response, status: :bad_request and return
        end

        if readPage > pageCount
            response = {:status => 'fail', :message => 'Gagal memperbarui buku. readPage tidak boleh lebih besar dari pageCount'}
            render :json => response, status: :bad_request and return
        end

        book = Book.find_by book_id: id

        if book.nil?
            response = {:status => 'fail', :message => 'Gagal memperbarui buku. Id tidak ditemukan'}
            render json: response, status: :not_found
        else
            book.update(name: name, year: year, author: author, summary: summary, publisher: publisher, page_count: pageCount, read_page: readPage, reading: reading)
    
            response = {:status => 'success', :message => 'Buku berhasil diperbarui'}
            render json: response, status: :ok
        end
    end

    def destroy
        id = params[:id]
        book = Book.find_by book_id: id

        if book.nil?
            response = {:status => 'fail', :message => 'Buku gagal dihapus. Id tidak ditemukan'}
            render json: response, status: :not_found
        else
            book.destroy
    
            response = {:status => 'success', :message => 'Buku berhasil dihapus'}
            render json: response, status: :ok
        end
    end

    def detail
        id = params[:id]
        book = Book.find_by book_id: id

        if book.nil?
            response = {:status => 'fail', :message => 'Buku tidak ditemukan'}
            render json: response, status: :not_found
        else
            response = {:status => 'success', :data => {:book => book.map_to_detail_json}}
            render json: response, status: :ok
        end
    end

    private
    def generateRandomId()
        return (0...16).map { ('a'..'z').to_a[rand(26)] }.join
    end
end