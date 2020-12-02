# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvImportForm, type: :form do
  describe '#save' do
    context 'given valid parameters' do
      it 'creates keywords' do
        file = fixture_file_upload('files/example.csv', 'text/csv')
        csv_import_form = described_class.new(user: Fabricate(:user))

        expect { csv_import_form.save(file: file) }.to change(Keyword, :count).by(6)
      end

      it 'returns true' do
        file = fixture_file_upload('files/example.csv', 'text/csv')
        csv_import_form = described_class.new(user: Fabricate(:user))

        expect(csv_import_form.save(file: file)).to be_truthy
      end
    end

    context 'given invalid parameters' do
      context 'given NO file' do
        it 'does NOT create keyword' do
          file = nil
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect { csv_import_form.save(file: file) }.to change(Keyword, :count).by(0)
        end

        it 'returns false' do
          file = nil
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect(csv_import_form.save(file: file)).to be_falsy
        end

        it 'contains error message' do
          file = nil
          csv_import_form = described_class.new(user: Fabricate(:user))

          csv_import_form.save(file: file)

          expect(csv_import_form.errors.messages).to eql(base: [I18n.t('keyword.file_cannot_be_blank')])
        end
      end

      context 'given invalid file type' do
        it 'does NOT create keyword' do
          file = fixture_file_upload('files/nimble.png')
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect { csv_import_form.save(file: file) }.to change(Keyword, :count).by(0)
        end

        it 'returns false' do
          file = fixture_file_upload('files/nimble.png')
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect(csv_import_form.save(file: file)).to be_falsy
        end

        it 'contains error message' do
          file = fixture_file_upload('files/nimble.png')
          csv_import_form = described_class.new(user: Fabricate(:user))

          csv_import_form.save(file: file)

          expect(csv_import_form.errors.messages).to eql(base: [I18n.t('keyword.file_must_be_csv')])
        end
      end

      context 'given no keyword csv' do
        it 'does NOT create keyword' do
          file = fixture_file_upload('files/no_keywords.csv', 'text/csv')
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect { csv_import_form.save(file: file) }.to change(Keyword, :count).by(0)
        end

        it 'returns false' do
          file = fixture_file_upload('files/no_keywords.csv', 'text/csv')
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect(csv_import_form.save(file: file)).to be_falsy
        end

        it 'contains error message' do
          file = fixture_file_upload('files/no_keywords.csv', 'text/csv')
          csv_import_form = described_class.new(user: Fabricate(:user))

          csv_import_form.save(file: file)

          expect(csv_import_form.errors.messages).to eql(base: [I18n.t('keyword.keyword_range')])
        end
      end

      context 'given more than 1,000 keywords csv' do
        it 'does NOT create keyword' do
          file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect { csv_import_form.save(file: file) }.to change(Keyword, :count).by(0)
        end

        it 'returns false' do
          file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')
          csv_import_form = described_class.new(user: Fabricate(:user))

          expect(csv_import_form.save(file: file)).to be_falsy
        end

        it 'contains error message' do
          file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')
          csv_import_form = described_class.new(user: Fabricate(:user))

          csv_import_form.save(file: file)

          expect(csv_import_form.errors.messages).to eql(base: [I18n.t('keyword.keyword_range')])
        end
      end
    end
  end
end
