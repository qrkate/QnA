shared_examples_for 'API files' do
  context 'files' do
    let(:file) { controller.files.first.blob }
    let(:files_response) { object_response['files'] }
    let(:file_response) { files_response.first }

    it 'rerurn list of files' do
      expect(files_response.size).to eq controller.files.size
    end

    it 'returns all public fields' do
      %w[id filename].each do |attr|
        expect(file_response[attr]).to eq file.send(attr).as_json
      end
    end

    it 'contains link to file' do
      expect(file_response['url']).to eq rails_blob_path(file).as_json
    end
  end
end
